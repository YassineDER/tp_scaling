# Reserve first node (strasbourg)

    # Setup k8s inside it 
    # create the deployment and service from the k8s/ folder   ( automatically )
    # Make "scripts/generate_profilage.sh" executable and run it

# Reserve second node (lille)

    # Same steps above

import requests

strasbourg_config = {
    'resources': 'nodes=1,walltime=1:00',
    'command': 'cd scripts && chmod +x *.sh && ./start.sh',
    'directory': '~/tp_scaling',
    'properties': '(cluster = \'fleckenstein\')',
    'name': 'Noeud1',
}
lille_config = {
    'resources': 'nodes=1,walltime=1:30',
    'name': 'Noeud2',
    'properties': '(cluster = \'chifflot\')',
    'directory': '~/tp_scaling',
    'command': 'cd scripts && chmod +x *.sh && ./start.sh',
}

reserve_strasbourg = requests.post('https://api.grid5000.fr/stable/sites/strasbourg/jobs?pretty', json=strasbourg_config, verify=False)
reserve_lille = requests.post('https://api.grid5000.fr/stable/sites/lille/jobs?pretty', json=lille_config, verify=False)

print("Strasbourg reservation response: \n")
print(reserve_strasbourg.text)
print("\n\n\n")
print("Lille reservation response: \n")
print(reserve_lille.text)

print("\n\n\n")
print("Jobs has been reserved successfully")