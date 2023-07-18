# Note: HowTo Setup Apache on Ubuntu 22.04 For User public_html

## Introduction
This is a short note on setting up the Apache web server to allow system users to create personal websites and web apps in their home directories. This is part of a larger project to set up a multi-user server resource at [Puget Systems](pugetsystems.com) for employees that want to learn to use and write apps with recent models and tools using LLMs and other generative AI apps. The system has a [Cockpit](https://cockpit-project.org/) web interface for managing the system and [JupyterHub](https://jupyter.org/hub) for JupyterLab notebook resources. 

An important component of this resource is a web server for hosting access to generative AI apps company-wide and for users to create their own personal websites and web apps. This note describes setting up Apache to allow user websites and apps from their home directories.

## Apache Configuration for User public_html
This a simple procedure, but there is one gotcha that may give you trouble since it seems not to be well described online.

The system I'm working on is,
- An Intel Sapphire Rapids platform
- Xeon w9-3475X 36-core CPU
- 256GB RAM
- Multiple 2TB NVMe SSDs
- 4 x NVIDIA RTX 6000Ada GPUs
- Ubuntu 22.04 LTS server 

### Install Apache
The first step is to install Apache2 and some optional convenience utilities.
```
sudo apt install apache2 apache2-utils
```

### Configure $HOME/public_html Directory access

This is done by enabling the Apache `userdir` module, restarting Apache, and configuring directory permissions and user groups to allow the webserver to access the user's home directories. On Ubuntu, the following commands do this.
```
sudo a2enmod userdir
```
That enables the `userdir` module and adds the following to `/etc/apache2/mods-enabled/userdir.conf`
```
<IfModule mod_userdir.c>
	UserDir public_html
	UserDir disabled root

	<Directory /home/*/public_html>
		AllowOverride FileInfo AuthConfig Limit Indexes
		Options MultiViews Indexes SymLinksIfOwnerMatch IncludesNoExec
		Require method GET POST OPTIONS
	</Directory>
</IfModule>
``` 

Restart Apache to enable the changes.
```
sudo systemctl restart apache2
```

This will set the user's $HOME/public_html as web root for their website.

### Directory Permissions and User Groups
The `userdir` module requires that a user's $HOME/public_html directory be readable by the webserver user, www-data, on Ubuntu. 

Two things are required for this,
- The directory $HOME/public_html must exist and have read/execute permission for "group" and
- The group www-data must be a member of the user's group.

The user (or admin) must create a `public_html` directory in their home directory with read/execute permission for "group." The default Ubuntu directory creation mask of 755 will do
```
mkdir ~/public_html
chmod 755 ~/public_html
```
The `chmod 755 ~/public_html` command is redundant on Ubuntu since it is the default permission mask. (The default user file creation mask is 644, which is sufficient for files in public_html.)

That gives the "user" read/write/execute permission (7), the user's "group" read/execute permission(5), and "other" read/execute permission(5).

The Apache user www-data must be a member of the user's group. This is done by adding the www-data user to the user's group.

**THIS IS PROBABLY THE OPPOSITE OF WHAT YOU MIGHT THINK!**
You are not adding the user to the www-data group. You are adding the www-data user to the user's group! Do this with,
```
sudo usermod -a -G <username> www-data
```
Make note of the order, `<username> www-data`. Doing this will give Apache user (www-data) access to the files and directories under public_html/ since that is the "document root" for the user's website.

Alternatively, you could change permissions on the user's home directory to allow "other" read/execute permission. This is not recommended because it would allow anyone to access the user's home directory and all of its contents if they know file/directory names. To make that permission change, you would use `chmod 751 ~` instead of the default `750` mask, which disallows "other" access.

If you don't do one of the above you will get the following error when you try to access the user's website, 

>**Forbidden**
>*You don't have permission to access this resource.*

I hope this is clear. It took me longer than I would like to get this straight which is partly why I'm writing this note!

### Test the User's Website
To test the user website, create a simple index.html file in the user's public_html directory. For example,
```
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Home</title>
</head>

<body>

    <h1>Your Site</h1>
    <p>Home page content goes here.</p>
    <p>Access it at 'server_address/~your_user_name/'

</body>

</html>
```
Then access the user's website at `server_address/~your_user_name/`. You should see the contents of the index.html file.

### Optional: add to /etc/skel
If you want to have a public_html directory and an index.html file by default for all new users, add `public_html/index.html` to `/etc/skel/`
You will still need to add the www-data user to the user's group for each new user that wants to use public_html.

## Conclusion
This is a simple procedure, but there is one gotcha with permissions that may give you trouble since it seems not to be well described online. I hope this note helps you get it right the first time.

**Happy computing! --dbk @dbkinghorn**


