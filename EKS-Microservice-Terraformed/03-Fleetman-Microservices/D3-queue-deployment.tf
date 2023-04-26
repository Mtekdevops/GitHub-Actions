# Resource: UserMgmt queue Kubernetes Deployment
resource "kubernetes_deployment_v1" "queue" {
  metadata {
    name = "queue"
    labels = {
      app = "queue"
    }
  }
 
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "queue"
      }
    }
    template {
      metadata {
        labels = {
          app = "queue"
        }
      }
      spec {
        container {
          image = "richardchesterwood/k8s-fleetman-queue:release2"
          name  = "queue"
          #image_pull_policy = "always"  # Defaults to Always so we can comment this
      }
    }
  }
}
}

# Resource: Kubernetes Service Manifest (Type: NodePort)
resource "kubernetes_service_v1" "queue_nodeport_service" {
  metadata {
    name = "fleetman-queue"
  }
  spec {
    selector = {
      app = kubernetes_deployment_v1.queue.spec.0.selector.0.match_labels.app
    }
    port {
      name = "http"
      port      = 8161
      node_port = 30010
    }
    port {
      name = "endpoint"
      port = 61616
    }

    type = "NodePort"
  }
}
