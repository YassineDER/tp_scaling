import requests

strasbourg_config = {
    'resources': 'nodes=1,walltime=0:45',
    'command': 'cd scripts && chmod +x *.sh && ./start.sh',
    'directory': '~/tp_scaling',
    'name': 'Noeud1',
}
lille_config = {
    'resources': 'nodes=1,walltime=0:45',
    'name': 'Noeud2',
    'directory': '~/tp_scaling',
    'command': 'cd scripts && chmod +x *.sh && ./start.sh',
}


reserve_strasbourg = requests.post('https://api.grid5000.fr/stable/sites/strasbourg/jobs?pretty', json=strasbourg_config, verify=False)
reserve_lille = requests.post('https://api.grid5000.fr/stable/sites/lille/jobs?pretty', json=lille_config, verify=False)

print("Strasbourg reservation job ID: ", reserve_strasbourg.json()['uid'])
print("Lille reservation job ID: ", reserve_lille.json()['uid'])

print("\n")
print("Jobs has been reserved successfully")