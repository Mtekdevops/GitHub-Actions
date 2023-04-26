# Resource: UserMgmt position-tracker Kubernetes Deployment
resource "kubernetes_deployment_v1" "position-tracker" {
  metadata {
    name = "position-tracker"
    labels = {
      app = "position-tracker"
    }
  }
 
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "position-tracker"
      }
    }
    template {
      metadata {
        labels = {
          app = "position-tracker"
        }
      }
      spec {
        container {
          image = "richardchesterwood/k8s-fleetman-position-tracker:release3"
          name  = "position-tracker"
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

# Resource: Kubernetes Service Manifest (Type: NodePort)
resource "kubernetes_service_v1" "pos-tracker_clusterip_service" {
  metadata {
    name = "fleetman-position-tracker"
  }
  spec {
    selector = {
      app = kubernetes_deployment_v1.position-tracker.spec.0.selector.0.match_labels.app
    }
    port {
      name = "http"
      port      = 8080
    }

    type = "ClusterIP"
  }
}
