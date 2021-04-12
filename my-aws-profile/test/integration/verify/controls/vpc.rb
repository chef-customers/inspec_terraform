# vpc.rb

aws_vpc_id = input('aws_vpc_id')

control 'aws-single-vpc-exists-check' do
  only_if { aws_vpc_id != '' }
  impact 1.0
  title 'Check to see if custom VPC exists.'
  describe aws_vpc(aws_vpc_id) do
    it { should exist }
  end
end
