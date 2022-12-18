resource "aws_iam_instance_profile" "image" {
  name = "image_profile"
  role = aws_iam_role.image.name
}

resource "aws_iam_role" "image" {
  name               = "image-role"
  description        = "The role for EC2 Image Builder"
  assume_role_policy = <<EOF
{
"Version": "2012-10-17",
"Statement": {
"Effect": "Allow",
"Principal": {"Service": "ec2.amazonaws.com"},
"Action": "sts:AssumeRole"
}
}
EOF
}
resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.image.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
resource "aws_iam_role_policy_attachment" "image_builder" {
  role       = aws_iam_role.image.name
  policy_arn = "arn:aws:iam::aws:policy/EC2InstanceProfileForImageBuilder"
}