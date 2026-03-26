terraform { 
  cloud { 
    
    organization = "sighe-nehemie-org" 

    workspaces { 
      name = "cli-driven" 
    } 
  } 
}

resource "time_sleep" "wait_10_seconds" {
    create_duration = "10s"
}