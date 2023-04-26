# Resource: UserMgmt WebApp Kubernetes Deployment
resource "kubernetes_deployment_v1" "webapp" {
  metadata {
    name = "webapp"
    labels = {
      app = "webapp"
    }
  }
 
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "webapp"
      }
    }
    template {
      metadata {
        labels = {
          app = "webapp"
        }
      }
      spec {
        container {
          image = "richardchesterwood/k8s-fleetman-webapp-angular:release2"
          name  = "webapp"
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

# ----testing different types of services----

# Resource: Kubernetes Service Manifest (Type: Load Balancer - Classic)
resource "kubernetes_service_v1" "webapp_lb_service" {
  metadata {
    name = "webapp-clb-service"
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

# Resource: Kubernetes Service Manifest (Type: NodePort)
resource "kubernetes_service_v1" "webapp_nodeport_service" {
  metadata {
    name = "fleetman-webapp"
  }
  spec {
    selector = {
      app = kubernetes_deployment_v1.webapp.spec.0.selector.0.match_labels.app
    }
    port {
      port        = 80
      node_port = 31280
    }

    type = "NodePort"
  }
}