# AI Prompts & Antwoorden – Week4 Ai Prompts.Md

**Vraag 1:** Vraag

**Antwoord 1:** Hoe maak ik 2 VMs met Terraform waarbij de IP’s automatisch in de Ansible inventory komen?

---

**Vraag 2:** Antwoord

**Antwoord 2:** Gebruik `local_file` in combinatie met de gegenereerde IP-adressen van je Terraform-resources.

---

**Vraag 3:** Vraag

**Antwoord 3:** Hoe gebruik ik handlers in Ansible binnen een role om Apache opnieuw op te starten bij config wijzigingen?

---

**Vraag 4:** Antwoord

**Antwoord 4:** Gebruik `notify: restart apache` binnen een taak en definieer in je role onder handlers `restart apache`.

---

**Vraag 5:** Vraag

**Antwoord 5:** Hoe gebruik ik inventory variabelen, group_vars en vars in een playbook tegelijk?

---

**Vraag 6:** Antwoord

**Antwoord 6:** Group_vars worden automatisch geladen per groep, vars kunnen in het playbook zelf, en inventory kan inline of in bestanden worden meegegeven.

---

