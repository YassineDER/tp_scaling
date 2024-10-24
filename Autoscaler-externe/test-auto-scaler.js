const { execSync } = require('child_process')
const axios = require('axios')
const urlAutoScaler = 'http://localhost:5000/json'
const urlLoadGenerator = 'http://localhost:4000/json'

let RequestInterval
let TargetDelay
let Scaling

var myArgs = process.argv.slice(2)
if (myArgs[0] == null || myArgs[1] == null) {
    console.log('Please provide RequestInterval, TargetDelay and Scaling as arguments')
    return
} else {
    RequestInterval = myArgs[0]
    TargetDelay = myArgs[1]
    Scaling = myArgs[2] ?? 'auto'
    console.log(`Run test for RequestInterval: ${RequestInterval} to reach TargetDelay: ${TargetDelay}` + ` with Scaling: ${Scaling}`)
}


function sendAxiosPost(url, dataObj) {
    axios.post(url, dataObj)
        .then((res) => {
            console.log(res.data);
        })
        .catch((err) => {
            //console.log(err);
            console.log('<=== ERROR ===>');
        })
}


console.log(`Scaling to 1 replica`)
execSync(`kubectl scale --replicas=1 -f ../k8s/k8-tp-04-busy-box-deployment.yaml && sleep 10`)

sendAxiosPost(urlLoadGenerator, {
    MessageType: 'Setting',
    UrlBusyBox: 'http://192.168.49.2:30100/json'
})

sendAxiosPost(urlAutoScaler, {
    MessageType: 'Command',
    NodeCommand: 'BuildLookupTable'
})

setTimeout(() => {
    sendAxiosPost(urlLoadGenerator, {
        MessageType: 'Command',
        NodeCommand: 'GenerateLoad',
        Duration: 30000, //10000ms = 10s
        Interval: RequestInterval, // 100 = 100 ms
        NumberOfPoints: 1000,
        TargetDelay: TargetDelay
    })

    sendAxiosPost(urlAutoScaler, {
        MessageType: 'Command',
        NodeCommand: Scaling,
        RequestInterval: RequestInterval,
        TotalDelay: TargetDelay
    })

}, 5000)
