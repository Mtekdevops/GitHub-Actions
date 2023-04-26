# Resource: UserMgmt position-simulator Kubernetes Deployment
resource "kubernetes_deployment_v1" "position-simulator" {
  metadata {
    name = "position-simulator"
    labels = {
      app = "position-simulator"
    }
  }
 
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "position-simulator"
      }
    }
    template {
      metadata {
        labels = {
          app = "position-simulator"
        }
      }
      spec {
        container {
          image = "richardchesterwood/k8s-fleetman-position-simulator:release2"
          name  = "position-simulator"
          #image_pull_policy = "always"  # Defaults to Always so we can comment this
          env {
            name = "SPRING_PROFILES_ACTIVE"
            value = "production-microservice"
        }
      }
    }
  }
}
}