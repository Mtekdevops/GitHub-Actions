# Resource: Kubernetes Storage Class
resource "kubernetes_storage_class_v1" "ebs_sc" {  
  metadata {
    name = "cloud-ssd"
  }
  storage_provisioner = "ebs.csi.aws.com"
}