# Resource: mongodb Kubernetes Deployment
resource "kubernetes_deployment_v1" "mongodb_deployment" {
  depends_on = [kubernetes_deployment_v1.mongodb_deployment,kubernetes_persistent_volume_claim_v1.pvc]
  metadata {
    name = "mongodb"
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "mongodb"
      }          
    }
    strategy {
      type = "Recreate"
    }  
    template {
      metadata {
        labels = {
          app = "mongodb"
        }
      }
      spec {
        volume {
          name = "mongodb-persistent-storage"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim_v1.pvc.metadata.0.name
            # claim_name = "ebs-mongodb-pv-claim"
          }
        }
        container {
          name = "mongodb"
          image = "mongo:4.0-xenial"
          port {
            container_port = 27017
            name = "mongodb"
          }
          volume_mount {
            name = "mongodb-persistent-storage"
            mount_path = "/data/db"
          }
        }
      }
    }      
  }
  
}

# Resource: Persistent Volume Claim
resource "kubernetes_persistent_volume_claim_v1" "pvc" {
  metadata {
    name = "mongo-pvc"
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    storage_class_name = "cloud-ssd" 
    resources {
      requests = {
        storage = "7Gi"
      }
    }
  }
}

# Resource: mongodb Cluster IP Service
resource "kubernetes_service_v1" "mongodb_clusterip_service" {
  metadata {
    name = "fleetman-mongodb"
  }
  spec {
    selector = {
      app = kubernetes_deployment_v1.mongodb_deployment.spec.0.selector.0.match_labels.app 
    }
    port {
      port        = 27017 # Service Port
    }
    type = "ClusterIP"   
  }
}