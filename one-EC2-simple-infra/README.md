# Ejemplo de uso de Terraform 01_simple_vps
En este ejemplo crearemos una máquina en ec2 simple con una clave SSH

# Configuración de AWS CLI
[Tenemos una guía para poder gestionar las credenciales de AWS](https://cursosdedesarrollo.com/2020/08/infraestructura-uso-de-terraform-instalacion-y-configuraciones-basicas/)
# Copia el fichero terraform.tfvars.examples
<code>cp terraform.tfvars.example terraform.tfvars</code>

Edita el fichero terraform.tfvars y pon tus propios valores, sobre todo el vpc_id y la clave ssh

# Inicialización del despliegue
<code>$ terraform init</code>
# Planificación del despliegue
<code>$ terraform plan</code>
# Despliegue de la infraestructura
<code>$ terraform apply</code>
# Destrucción de la infraestructura
<code>$ terraform destroy</code>
