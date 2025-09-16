Отредактируйте файл backend.tf
```
bucket     = "<имя бакета созданного на предыдущем шаге>" 
```

Отредактируйте файл personal.auto.tfvars
```
cloud_id = "<...>"

folder_id = "<...>"

service_account_id = "<...>"
```

Инициализируйте Terraform с указанием файла конфигурации (предварительно записав в него access_key и secret_key полученный на предыдущем шаге)

```
terraform init -backend-config=backend.hcl
```
 
Создайте ресурсы

```
terraform apply
```

Добавьте адреса кластера в inventory файл kubespray/inventory/mycluster/inventory.ini (для работы с kubespray воспользуйтесь памяткой в фале kubespray.txt)

```
[kube_control_plane]
node1 ansible_host=<адрес мастера> ansible_user=<username>

[etcd:children]
kube_control_plane

[kube_node]
node2 ansible_host=<адрес воркер ноды> ansible_user=<username>
node3 ansible_host=<адрес воркер ноды> ansible_user=<username>
```

После установки инастройки k8s перенесите конфиг в $HOME/.kube/config и для подключения используйте ssh-тунель
```
ssh -L 6443:localhost:6443 <имя пользователя>@<адрес мастера> - Этот туннель перенаправит локальный порт 6443 на порт 6443 master-ноды
```


---

Отредактируйте файл systemd-юнита для kubelet, добавьте аргументы в секции ExecStart, что бы балансировщик смог успешно отработать healthcheck:
```
sudo nano /etc/systemd/system/kubelet.service
/*
ExecStart=/usr/bin/kubelet \
    # ... другие аргументы ...
    --healthz-bind-address=0.0.0.0 \
    --healthz-port=10248
*/
sudo systemctl daemon-reload
sudo systemctl restart kubelet
```

Отредактируйте конфигурационный файл kubelet:

sudo nano /var/lib/kubelet/config.yaml

healthzBindAddress: 0.0.0.0

sudo systemctl restart kubelet

cat /var/lib/kubelet/config.yaml | grep -i "address\|port"

---