const { execSync } = require('child_process')
const axios = require('axios')
const urlLoadGenerator = 'http://localhost:4000/json'

let RequestInterval
let NumberOfReplicas

var myArgs = process.argv.slice(2)
if (myArgs[0] == null) {
    console.log('Please provide NumberOfReplicas and RequestInterval')
    console.log(' ==> node test-load-generator.js $RequestInterval $NumReplicas')
    console.log('        ... for example ...')
    console.log('     node test-load-generator.js 100 3')

    return
} else {
    RequestInterval = myArgs[0]
    NumberOfReplicas = myArgs[1]
    console.log(`Run test for RequestInterval: ${RequestInterval} with NumberOfReplicas: ${NumberOfReplicas}`)
}


function sendAxiosPost(url, dataObj) {
    axios.post(url, dataObj)
        .then((res) => {
            console.log(res.data);
        })
        .catch((err) => {
            console.log(err);
        })
}

// Scale the deployment
console.log(`Execute => kubectl scale --replicas=${NumberOfReplicas} -f ../k8s/k8-tp-04-busy-box-deployment.yaml`)
execSync(`kubectl scale --replicas=${NumberOfReplicas} -f ../k8s/k8-tp-04-busy-box-deployment.yaml`)


setTimeout(() => {
    sendAxiosPost(urlLoadGenerator, {
        MessageType: 'Setting',
        UrlBusyBox: 'http://192.168.49.2:30100/json'
    })


    sendAxiosPost(urlLoadGenerator, {
        MessageType: 'Command',
        NodeCommand: 'GenerateLoad',
        Duration: 10000, //10000ms = 10s
        Interval: RequestInterval,
        NumberOfPoints: 1500,
        TargetDelay: 25
    })


    setTimeout(() => {
        const hostname = execSync('hostname -s').toString().trim()
        sendAxiosPost(urlLoadGenerator, {
            MessageType: 'Command',
            NodeCommand: 'SaveCollectedData',
            FileName: `collected-profiles-${hostname}/results-${NumberOfReplicas.toString()}-${RequestInterval.toString()}-raw.json`
        })
    }, 11000);

}, 5000)
