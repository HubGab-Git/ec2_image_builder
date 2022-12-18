resource "aws_imagebuilder_image_pipeline" "image" {
  image_recipe_arn                 = aws_imagebuilder_image_recipe.image.arn
  infrastructure_configuration_arn = aws_imagebuilder_infrastructure_configuration.image.arn
  name                             = "image"
}

resource "aws_imagebuilder_infrastructure_configuration" "image" {
  instance_profile_name         = aws_iam_instance_profile.image.name
  instance_types                = ["t3.nano"]
  name                          = "image"
  terminate_instance_on_failure = true
}

resource "aws_imagebuilder_image_recipe" "image" {
  block_device_mapping {
    device_name = "/dev/xvdb"

    ebs {
      delete_on_termination = true
      volume_size           = 8
      volume_type           = "gp2"
    }
  }

  component {
    component_arn = aws_imagebuilder_component.image.arn
  }

  name         = "image"
  parent_image = "ami-0fe0b2cf0e1f25c8a"
  version      = "1.0.0"
}

resource "aws_imagebuilder_component" "image" {
  data = yamlencode({
    phases = [{
      name = "build"
      steps = [{
        action = "ExecuteBash"
        inputs = {
          commands = [
            "sudo yum update -y",
            "sudo yum install java-11-amazon-corretto -y",
            "sudo yum install docker -y",
            "curl https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip",
            "unzip awscliv2.zip",
            "sudo ./aws/install",
            ]
        }
        name      = "InstallComponents"
        onFailure = "Continue"
      }]
    }]
    schemaVersion = 1.0
  })
  name     = "image"
  platform = "Linux"
  version  = "1.0.0"
}