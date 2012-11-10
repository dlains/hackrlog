## Welcome to hackrLog()

hackrLog() helps programmers keep development logs, personal notes, tricky configuration settings and any other bits of information that needs to be kept handy.

Every log entry is tagged so tracking down that three year old note is easy. 

### Setup Development Environment

Clone the repository from Github with the following command:

`clone git@github.com:dlains/hackrlog.git`

This will create a new `hackrlog` directory with the source code in the directory where you run the command. Now make sure your
machine has all of the gems required by the application.

`
cd hackrlog
bundle install
`

The next step is to make sure the database is setup.

Install MySQL on your machine if you haven't already. A good guide to building MySQL from source on OS X can be found [here](http://hivelogic.com/articles/compiling-mysql-on-snow-leopard/).

Now you need to create the hackrlog user and grant privileges for that user. Start MySQL with the root account and the password you created for root.

`mysql -u root -p`

Then enter the following commands the create the hackrlog user for the development and test databases.

```sql
create user 'hackrlog'@'localhost' identified by 'h4ckrl0g43v3r';
grant select, insert, update, delete, create, alter, drop, index, lock tables on hackrlog.* to 'hackrlog'@'localhost';
grant select, insert, update, delete, create, alter, drop, index, lock tables on hackrlog_test.* to 'hackrlog'@'localhost';
```

Now you should be able to run the rake database tasks.

`
rake db:create
rake db:migrate
rake db:seed
rake db:test:prepare
`

Optionally you can fill the database with some test data that is provided in a SQL script.

`mysql -u root -p hackrlog < script/fill.sql`

TODO: Add additional information here about setting up Nginx on OS X and configuring it to work with the hackrLog() project.

### Starting And Stopping

To run hackrLog() on your development maching first start Nginx and then Unicorn.

`
sudo nginx
unicorn
`

You must run Nginx with sudo in order for it to have access to the logging files. To stop hackrLog() on your machine use
CTRL-C to shut Unicorn down and the stop Nginx.

`sudo nginx -s stop`

You should also have another terminal tab open and running Guard. Guard watches selected directories in the application and will
automatically run the test suite when changes are made to the code. Start Guard with:

`bundle exec guard`

Like Unicorn, you can stop Guard with CTRL-C.

Also, when the tests are run a code coverage report is generated. To see this report open `coverage/index.html` in a browser.