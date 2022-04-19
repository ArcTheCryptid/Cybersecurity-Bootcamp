# Cybersecurity-Bootcamp
All my Project 1 files from DU's Cybersecurity Bootcamp from 2021-2022.
## Automated ELK Stack Deployment

The files in this repository were used to configure the network depicted below.

![Cloud Diagram](https://raw.githubusercontent.com/ArcTheCryptid/Cybersecurity-Bootcamp/Diagrams/Homework_12_Diagram.png)

^ This diagram was from a previous iteration, so IP's are different from current scripts, however this gives an idea of what the topology looks like.

These files have been tested and used to generate a live ELK deployment on Azure. They can be used to either recreate the entire deployment pictured above. Alternatively, select portions of the YAML files may be used to install only certain pieces of it, such as Filebeat.

  - [Ansible YAML Files](https://github.com/ArcTheCryptid/Cybersecurity-Bootcamp/tree/Ansible)



This document contains the following details:
- Description of the Topology
- Access Policies
- ELK Configuration
  - Beats in Use
  - Machines Being Monitored
- How to Use the Ansible Build


### Description of the Topology

The main purpose of this network is to expose a load-balanced and monitored instance of DVWA, the Damn Vulnerable Web Application.

Load balancing ensures that the application will be highly available, in addition to restricting traffic to the network.

- What aspect of security do load balancers protect? 
    - Load Balancers help protect the network from DDOS attacks, so that services are not severely interrupted. They also help prevent servers from being overloaded and can help keep things running smoothly if one goes down for some reason, such as maintenence or a failure.


- What is the advantage of a jump box?
    - A Jump Box gives us a central main VM for monitoring, maintaining, and logging network traffic. The jump box can be used to connect to Azure VM's and servers without having to worry as much about exposure to unauthorized personnel, especially with a default-deny policy applied.


Integrating an ELK server allows users to easily monitor the vulnerable VMs for changes to the network and system logs.

- What does Filebeat watch for?
  - Filebeat watches for and gathers log files and forwards them to your SIEM, in this case Elasticsearch, which we then browse and filter through with Kibana. 

- What does Metricbeat record?
  - Metricbeat records stats and metrics and forwards them to your SIEM, in our case also Elasticsearch, which we can then view in Kibana.

The configuration details of each machine may be found below.

| **Name**  | **Function** | **IP Address** | **Operating System** |
|-----------|--------------|----------------|----------------------|
| Jump Box  | Gateway      | 10.0.0.1       | Linux                |
| Web-1     | Server       | 10.1.0.5       | Linux                |
| Web-2     | Server       | 10.0.0.7       | Linux                |
| ELK-Stack | VM           | 10.1.0.4       | Linux                |

### Access Policies

The machines on the internal network are not exposed to the public Internet. 

Only the Jump Box machine can accept connections from the Internet. Access to this machine is only allowed from the following IP addresses:

- Personal Workstation IP
- 10.0.0.5
- 10.0.0.7

Machines within the network can only be accessed by the Personal Workstation connected to Jump Box via SSH.
- Which machine did you allow to access your ELK VM? What was its IP address?
  - Jump Box VM : 10.0.0.1 
  - Workstation : Personal Workstation IP

A summary of the access policies in place can be found in the table below.
| **Name**  | **Publicly Accessible** | **Allowed IP Addresses**                       |
|-----------|-------------------------|------------------------------------------------|
| Jump Box  | Yes                     | 10.0.0.5, 10.0.0.7, My Personal Workstation IP |
| Web-1     | No                      | 10.0.0.4                                       |
| Web-2     | No                      | 10.0.0.4                                       |
| ELK-Stack | No                      | 10.0.0.5, 10.0.0.7, My Personal Workstation IP |

### Elk Configuration

Ansible was used to automate configuration of the ELK machine. No configuration was performed manually, which is advantageous because it saves time, resources, and is less suceptible to human error (as long as it's configured correctly, of course.)
  
- What is the main advantage of automating configuration with Ansible?
  - Saving time by making the deployment of Ansible containers quick and easy.

The playbook implements the following tasks:

- Install docker and ELK
  
```  
---
- name: Install docker and ELK
  hosts: elk
  become: true
  tasks:
    - name: resize vm memory
      sysctl:
        name: vm.max_map_count
        value: '262144'
        state: present
        reload: yes
```
  
  - Install Docker
  
```
    - name: Install Docker.io
      apt:
        update_cache: yes
        name: docker.io
        state: present
```
  
  - Install pip and use it to install a Python 3 Docker container
  
```  
    - name: Install pip
      apt:
        name: python3-pip
        state: present

    - name: use pip to install python3 docker container
      pip:
        name: docker
        state: present
```  
  
  - Downloads image and launches ELK container
  
```  
    - name: Download and launch ELK container
      docker_container:
        name: elk
        image: sebp/elk:761
        state: started
        restart_policy: always
        published_ports:
          - 5601:5601
          - 9200:9200
          - 5044:5044
```
  
  - Enables Docker services and launches
  
```
    - name: enable docker services
      systemd:
        name: docker
        enable: yes

    - name: start service with systemd
      systemd:
        name: docker
        enabled: yes
```  
  
### Target Machines & Beats
This ELK server is configured to monitor the following machines:
- Web-1
- Web-2
- ELK-Stack

We have installed the following Beats on these machines:
- Filebeat
- Metricbeat 

These Beats allow us to collect the following information from each machine:
-   Filebeat collects data in regards to log files, such as audit logs, which we can use to see who made changes and when.
-   Metricbeat collects server metrics, such as CPU or memory usage, which helps us monitor the status of our VM's and servers.
  
### Using the Playbook
In order to use the playbook, you will need to have an Ansible control node already configured. Assuming you have such a control node provisioned: 

SSH into the control node and follow the steps below:
- Copy the config file to your Ansible directory.
- Update the config file to include your users, ports, and IP addresses.
- Run the playbook, and navigate to Kibana to check that the installation worked as expected.

### Configuring Files

- Which file is the playbook? Where do you copy it?
    - [ELKStack-config.yml](https://github.com/ArcTheCryptid/Cybersecurity-Bootcamp/blob/Ansible/ELKStack-config.yml) ; Copy this over to your ```/etc/ansible``` directory.
  
- Which file do you update to make Ansible run the playbook on a specific machine? 
    - Be sure to edit your ```/etc/ansible/hosts``` file to reflect the IP of the machine you wish to use.
  
- How do I specify which machine to install the ELK server on versus which to install Filebeat on?
    - Have multiple sections in your ```/etc/ansible/hosts``` file. One to establish which machine you want your ELK server to be installed on, and another section for the machines you want Filebeat on.
  
- Which URL do you navigate to in order to check that the ELK server is running?
    - http://(insert IP address here):5601//app/kibana
      - for example, http://10.0.0.4:5601//app/kibana

### Additional Resources

  - [Other Linux Scripts We've Made In The Bootcamp](https://github.com/ArcTheCryptid/Cybersecurity-Bootcamp/tree/Ansible)
