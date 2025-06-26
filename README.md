# les4-alles

# Infrastructure as Code – Week 4

## Inhoud

Deze repository bevat de uitwerkingen van week 4 van de Infrastructure as Code-opdracht. In deze week is een volledige infrastructuur uitgerold met behulp van Terraform (voor VM-creatie) en Ansible (voor configuratie), inclusief het gebruik van zelfgemaakte rollen.

---

## Mappenstructuur

- `terraform/` – Terraform-code voor het aanmaken van VM's
- `roles/` – Bevat Ansible-rollen voor de `webserver` en `dbserver`
- `group_vars/` – Variabelen per hostgroep
- `inventory.ini` – Ansible-inventory met IP’s van de VM’s
- `playbook.yml` – Startpunt van de Ansible-configuratie
- `screenshots bewijs/` – Bewijsmateriaal van werkende configuraties
- `screenshots galaxy/` – Bewijs van succesvolle Ansible Galaxy-publicatie

---

## Terraform

De map `terraform/` bevat:

- `main.tf`, `providers.tf` – Azure providerconfiguratie en VM-setup
- `variables.tf`, `terraform.tfvars` – Declaratie van gebruikte variabelen

### Uitvoeren

1. Navigeer naar de map:
   ```bash
   cd terraform
2. Initialiseer Terraform:
   terraform init
3. Voer uit:
   terraform apply -auto-approve

Resultaat: 2 Ubuntu-VM’s worden uitgerold in Azure – één webserver, één databaseserver.

Ansible
Er zijn twee rollen gemaakt:

webserver: installeert Apache, PHP en PHP-MySQL

dbserver: installeert en configureert MySQL

Deze zijn gepubliceerd op Ansible Galaxy (zie map screenshots galaxy/).

Playbook-structuur
Startbestand: playbook.yml

Voorbeeld:

- hosts: webservers
  roles:
    - webserver

- hosts: dbservers
  roles:
    - dbserver
Inventory
Voorbeeld uit inventory.ini:

[webservers]
vm1 ansible_host=20.123.45.67

[dbservers]
vm2 ansible_host=20.123.45.68
Uitvoeren:
ansible-playbook -i inventory.ini playbook.yml

Zorg dat de SSH-key correct staat en de gebruiker iac toegang heeft.

Variabelen & Gebruikers
group_vars/webservers.yml en group_vars/dbservers.yml bevatten configuratie

Database login:

User: dbuser

Password: dbpassword

Resultaten
- Terraform: succesvolle deploy van 2 Azure-VM’s
- Ansible: werkende configuratie met handlers en variabelen
- Rollen gestructureerd en gepubliceerd op Galaxy
- Bewijsscreenshots meegeleverd
- README met volledige uitleg en instructies
