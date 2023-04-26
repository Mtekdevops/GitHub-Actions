# Resource: UserMgmt api-gateway Kubernetes Deployment
resource "kubernetes_deployment_v1" "api-gateway" {
  metadata {
    name = "api-gateway"
    labels = {
      app = "api-gateway"
    }
  }
 
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "api-gateway"
      }
    }
    template {
      metadata {
        labels = {
          app = "api-gateway"
        }
      }
      spec {
        container {
          image = "richardchesterwood/k8s-fleetman-api-gateway:release2"
          name  = "api-gateway"
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
resource "kubernetes_service_v1" "api-gateway_nodeport_service" {
  metadata {
    name = "fleetman-api-gateway"
  }
  spec {
    selector = {
      app = kubernetes_deployment_v1.api-gateway.spec.0.selector.0.match_labels.app
    }
    port {
      name = "http"
      port      = 8080
      node_port = 30020
    }

    type = "NodePort"
  }
}

# Resource: Kubernetes Service Manifest (Type: Load Balancer - Network)
resource "kubernetes_service_v1" "webapp_network_lb_service" {
  metadata {
    name = "webapp-network-lb-service"
    annotations = {
      "service.beta.kubernetes.io/aws-load-balancer-type" = "nlb"    # To create Network Load Balancer
    }
  }
  spec {
    selector = {
      app = kubernetes_deployment_v1.webapp.spec.0.selector.0.match_labels.app
    }
    port {
      port        = 80
    }
    type = "LoadBalancer"
  }
}

