# Laravel 8 Boilerplate Multi Auth, Passport, Datatables, Simple and User Friendly

## Features

    1. Laravel 8 Framework
    2. Laravel-Permission by spatie/laravel-permission
    3. Laravel Backup by spatie/laravel-backup
    4. Yajra Datatable by Yajra
    5. Laravel Debugbar
    6. Laravel Passport Authentication
    7. Laravel Ajax CRUD
    8. Bootstrap 4
    9. Architect Admin Template
    10. Multi Auth
    11. Admin Panel & User Panel

### Requirements

    1. PHP version upto 8.1.28    
    2. Laravel version  8  

### Installation

    1. Clone the project using git clone   
    2. Copy a fresh .env file from laravel github    
    3. Update .env file by adding database information like DB_HOST.  
    4. Go to project root folder.Open git bash or terminal and run  composer install       
    5. Run php artisan key:generate in the terminal    
    6. import db.sql from db folder

### Troubleshootings

    1. Change Db port in config/database.php file or change as yours.
    2. Try composer composer dump-autoload if need
    3. php artisan config:cache if need
    4. php artisan clear-compiled if need    

### Login

         // admin
         email : superadmin@admin.com
         pass :  123456
         
         // user
         email:userone@admin.com
         pass : 123456

http://localhost:8080/admin_login/login
http://localhost:8080/user_login/login

Screenshot :

![alt text](./screenshot/Home.png)
![alt text](./screenshot/dashboard.png)
![alt text](./screenshot/Users.png)
![alt text](./screenshot/Blogs.png)
![alt text](./screenshot/Permissions.png)
