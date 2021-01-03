Udemy - AWS Certified ML Speciality (with Terraform)

`terraform init`
`terraform apply`

## Kinesys

Start test data stream:
![](img/2020-12-30-16-31-05.png)

After a few minutes you should see data in your bucket:
![](img/2020-12-30-16-31-52.png)

Now, start the analytics application:
![](img/2020-12-30-16-33-00.png)

After a few minutes you should see more data in your bucket:
![](img/2020-12-30-16-33-37.png)

## Glue

Kick off the crawler:
![](img/2020-12-30-16-34-15.png)

## EMR

Open SSH tunnel to your instance on Zeppelin's port:
`ssh -NL 8157:ec2-54-185-168-159.us-west-2.compute.amazonaws.com:8890 hadoop@ec2-54-185-168-159.us-west-2.compute.amazonaws.com`

Open `http://localhost:8157/` in the browser and import TF-IDF.json notebook. Step through code with Shift+Enter