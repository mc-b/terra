## Übung 05-4: AWS - Terragrunt - Stack

Für das deployen verschiedener Mandanten verwenden wir `terragrunt stack`.

Wir wollen mehrere Mandanten gleichzeitig deployen mit jeweils unterschiedlichen Software Releases.
    
### Übung

Erstellt folgende Datei `terragrunt.stack.hcl`

    unit "mandant_01" {
      source = "../05-4-aws-terragrunt/prod"        # Input
      path = "m01"                                  # Output
    
      no_dot_terragrunt_stack = true
    
      values = {
        environment = "m01"
      }
    }
    
    unit "mandant_02" {
      source = "../05-4-aws-terragrunt/test"
      path = "m02"
    
      no_dot_terragrunt_stack = true
    
      values = {
        environment = "m02"
      }
    }
    
    unit "mandant_03" {
      source = "../05-4-aws-terragrunt/dev"
      path = "m03"
    
      no_dot_terragrunt_stack = true
    
      values = {
        environment = "m03"
      }
    }

### Deployment

Zuerst erstellen wir die Mandanten Umgebungen

    terragrunt stack generate
    
Um anschliessend alle Mandanten gleichzeit zu deployen

    terragrunt stack run apply 
    
### Aufräumen

    terragrunt stack run destroy         
     