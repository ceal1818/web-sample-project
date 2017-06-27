# Proyecto de ejemplo PHP7 y MySQL: CRUD

Para empezar a trabajar en este proyecto es necesario seguir las siguientes instrucciones:

## Crear tabla de usuarios
1. En el directorio **sql** encontraremos el fichero **app-dump.sql** que contiene la estructura de la tabla "users" que necesitamos para la práctica.

2. Para poder utilizar crear la tabla y cargar estos datos de pruebas necesitamos ejecutar estos datos con el MySQL Client desde cualquier ordenador donde este instalado.

```[shell]
mysql -h[HOST_MYSQL_SERVER] -u appuser -p app < app-dump.sql

```

## Listar usuarios.

1. Comprobar y corregir los datos de conexión a la base de datos en el fichero **database.php**:

```[php]
    private static $dbName = 'app' ;
    private static $dbHost = [HOST_MYSQL_SERVER] ;
    private static $dbUsername = 'appuser';
    private static $dbUserPassword = [password];
```

2. En el fichero index.html debemos incluir el código php que permitirá listar los registros de usuarios, justo después del encabezado de la tabla de resultados.

```[php]
<?php
	include 'database.php';
	$pdo = Database::connect();
	$sql = 'SELECT * FROM users ORDER BY id DESC';
	foreach ($pdo->query($sql) as $row) {
 		echo '<tr>';
 		echo '<td>'. $row['first_name'] .'</td>';
		echo '<td>'. $row['last_name'] .'</td>';
		echo '<td>'. $row['email'] .'</td>';
		echo '<td width=250>';
		// Acceso a la pantalla para ver un usuario
		echo '<a class="btn" href="#">Read</a>';
        	echo ' ';
        	// Acceso a la pantalla para actualizar un usuario
        	echo '<a class="btn btn-success" href="#">Update</a>';
        	echo ' ';
        	// Acceso a la pantalla para eliminar un usuario
        	echo '<a class="btn btn-danger" href="#">Delete</a>';
        	echo '</td>';
		echo '</tr>';
        }
	Database::disconnect();
?>
```

3. Probamos.

## Create User - Crear usuario.

1. Creamos el fichero **create.php** y le incluimos el siguiente contenido HTML:
```[html]
<!DOCTYPE html>
<html lang="en">
<head>
    <title>PHP CRUD - Create a User</title>
    <meta charset="utf-8">
    <link   href="css/bootstrap.min.css" rel="stylesheet">
    <script src="js/bootstrap.min.js"></script>
</head>
 
<body>
    <div class="container">
     
                <div class="span10 offset1">
                    <div class="row">
                        <h3>Create a User</h3>
                    </div>
             
                    <form class="form-horizontal" action="create.php" method="post">
                      <div class="control-group <?php echo !empty($nameError)?'error':'';?>">
                        <label class="control-label">First Name</label>
                        <div class="controls">
                            <input name="first_name" type="text"  placeholder="First Name" value="<?php echo !empty($firstName)?$firstName:'';?>">
                            <?php if (!empty($nameError)): ?>
                                <span class="help-inline"><?php echo $nameError;?></span>
                            <?php endif; ?>
                        </div>
                      </div>
                      <div class="control-group <?php echo !empty($nameError)?'error':'';?>">
                        <label class="control-label">Last Name</label>
                        <div class="controls">
                            <input name="last_name" type="text" placeholder="Last Name" value="<?php echo !empty($lastName)?$lastName:'';?>">
                            <?php if (!empty($nameError)): ?>
                                <span class="help-inline"><?php echo $nameError;?></span>
                            <?php endif;?>
                        </div>
                      </div>
                      <div class="control-group <?php echo !empty($emailError)?'error':'';?>">
                        <label class="control-label">Email</label>
                        <div class="controls">
                            <input name="email" type="text"  placeholder="Email" value="<?php echo !empty($email)?$email:'';?>">
                            <?php if (!empty($emailError)): ?>
                                <span class="help-inline"><?php echo $emailError;?></span>
                            <?php endif;?>
                        </div>
                      </div>
                      <div class="form-actions">
                          <button type="submit" class="btn btn-success">Create</button>
                          <a class="btn" href="index.php">Back</a>
                        </div>
                    </form>
                </div>
                 
    </div> <!-- /container -->
  </body>
</html>
```

2. Al principio de este fichero, insertamos el código php de validación del formulario y de creación del usuario.

```[php]
<?php
    require 'database.php';
 
    if ( !empty($_POST)) {
        // keep track validation errors
        $nameError = null;
        $emailError = null;
         
        // keep track post values
        $firstName = $_POST['first_name'];
        $lastName = $_POST['last_name'];
        $email = $_POST['email'];
         
        // validate input
        $valid = true;
        if (empty($firstName)) {
            $nameError = 'Please enter First Name';
            $valid = false;
        }

        if (empty($lastName)) {
            $nameError = 'Please enter Last Name';
            $valid = false;
        }
         
        if (empty($email)) {
            $emailError = 'Please enter Email Address';
            $valid = false;
        } else if ( !filter_var($email,FILTER_VALIDATE_EMAIL) ) {
            $emailError = 'Please enter a valid Email Address';
            $valid = false;
        }
         
        // insert data
        if ($valid) {
            $pdo = Database::connect();
            $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
            $sql = "INSERT INTO users (first_name,last_name,email) values(?, ?, ?)";
            $q = $pdo->prepare($sql);
            $q->execute(array($firstName,$lastName,$email));
            Database::disconnect();
            header("Location: index.php");
        }
    }
?>
```

## Read User - Ver Usuario.

Para empezar a ver el usuario que hemos creado debemos seguir los siguientes pasos:

1. Creamos el fichero **read.php** e incluimos el siguiente código HTML.
```[html]
<!DOCTYPE html>
<html lang="en">
<head>
    <title>PHP CRUD - Read a User</title>
    <meta charset="utf-8">
    <link   href="css/bootstrap.min.css" rel="stylesheet">
    <script src="js/bootstrap.min.js"></script>
</head>
<body>
    <div class="container">
     
                <div class="span10 offset1">
                    <div class="row">
                        <h3>Read a User</h3>
                    </div>
                     
                    <div class="form-horizontal" >
                      <div class="control-group">
                        <label class="control-label">First Name</label>
                        <div class="controls">
                            <label class="checkbox">
                                <?php echo $data['first_name'];?>
                            </label>
                        </div>
                      </div>
                      <div class="control-group">
                        <label class="control-label">Last Name</label>
                        <div class="controls">
                            <label class="checkbox">
                                <?php echo $data['last_name'];?>
                            </label>
                        </div>
                      </div>
                      <div class="control-group">
                        <label class="control-label">Email</label>
                        <div class="controls">
                            <label class="checkbox">
                                <?php echo $data['email'];?>
                            </label>
                        </div>
                      </div>
                        <div class="form-actions">
                          <a class="btn" href="index.php">Back</a>
                       </div>
                     
                      
                    </div>
                </div>
                 
    </div> <!-- /container -->
  </body>
</html>
```
2. Añadimos el fichero **read.php** el código php para obtener el registro de usuario de la tabla **users**.
```[php]
<?php
    require 'database.php';
    $id = null;
    if ( !empty($_GET['id'])) {
        $id = $_REQUEST['id'];
    }
     
    if ( null==$id ) {
        header("Location: index.php");
    } else {
        $pdo = Database::connect();
        $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        $sql = "SELECT * FROM users where id = ?";
        $q = $pdo->prepare($sql);
        $q->execute(array($id));
        $data = $q->fetch(PDO::FETCH_ASSOC);
        Database::disconnect();
    }
?>
```
3. Debemos modificar el fichero **index.php** incluyendo el acceso a la página **read.php** pasandole como parámetro el ID del usuario.
```[php]
...
echo '<a class="btn" href="read.php?id='.$row['id'].'">Read</a>';
...
```

## Update User - Actualizar usuario
Para actualizar cualquier usuario debemos seguir los siguientes pasos:
1. Creamos el fichero **update.php** e incluimos el siguiente código HTML.
```[html]
<!DOCTYPE html>
<html lang="en">
<head>
    <title>PHP CRUD - Update a User</title>
    <meta charset="utf-8">
    <link   href="css/bootstrap.min.css" rel="stylesheet">
    <script src="js/bootstrap.min.js"></script>
</head>
 
<body>
    <div class="container">
     
                <div class="span10 offset1">
                    <div class="row">
                        <h3>Update a User</h3>
                    </div>
             
                    <form class="form-horizontal" action="update.php?id=<?php echo $id?>" method="post">
                      <div class="control-group <?php echo !empty($nameError)?'error':'';?>">
                        <label class="control-label">First Name</label>
                        <div class="controls">
                            <input name="first_name" type="text"  placeholder="First Name" value="<?php echo !empty($firstName)?$firstName:'';?>">
                            <?php if (!empty($nameError)): ?>
                                <span class="help-inline"><?php echo $nameError;?></span>
                            <?php endif; ?>
                        </div>
                      </div>
                      <div class="control-group <?php echo !empty($nameError)?'error':'';?>">
                        <label class="control-label">Last Name</label>
                        <div class="controls">
                            <input name="last_name" type="text"  placeholder="Last Name" value="<?php echo !empty($lastName)?$lastName:'';?>">
                            <?php if (!empty($nameError)): ?>
                                <span class="help-inline"><?php echo $nameError;?></span>
                            <?php endif; ?>
                        </div>
                      </div>
                      <div class="control-group <?php echo !empty($emailError)?'error':'';?>">
                        <label class="control-label">Email Address</label>
                        <div class="controls">
                            <input name="email" type="text" placeholder="Email Address" value="<?php echo !empty($email)?$email:'';?>">
                            <?php if (!empty($emailError)): ?>
                                <span class="help-inline"><?php echo $emailError;?></span>
                            <?php endif;?>
                        </div>
                      </div>
                      <div class="form-actions">
                          <button type="submit" class="btn btn-success">Update</button>
                          <a class="btn" href="index.php">Back</a>
                        </div>
                    </form>
                </div>
                 
    </div> <!-- /container -->
  </body>
</html>
```
2. Añadimos al principio del fichero **update.php** el código php para actualizar el registro de usuario de la tabla **users**.
```[php]
<?php
    require 'database.php';
 
    $id = null;
    if ( !empty($_GET['id'])) {
        $id = $_REQUEST['id'];
    }
     
    if ( null==$id ) {
        header("Location: index.php");
    }
     
    if ( !empty($_POST)) {
        // keep track validation errors
        $nameError = null;
        $emailError = null;
         
        // keep track post values
        $firstName = $_POST['first_name'];
        $lastName = $_POST['last_name'];
        $email = $_POST['email'];
         
        // validate input
        $valid = true;
        if (empty($firstName)) {
            $nameError = 'Please enter First name';
            $valid = false;
        }
         
        if (empty($lastName)) {
            $nameError = 'Please enter Last name';
            $valid = false;
        }

        if (empty($email)) {
            $emailError = 'Please enter Email Address';
            $valid = false;
        } else if ( !filter_var($email,FILTER_VALIDATE_EMAIL) ) {
            $emailError = 'Please enter a valid Email Address';
            $valid = false;
        }
         
        // update data
        if ($valid) {
            $pdo = Database::connect();
            $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
            $sql = "UPDATE users  set first_name = ?, last_name = ?, email = ? WHERE id = ?";
            $q = $pdo->prepare($sql);
            $q->execute(array($firstName,$lastName,$email,$id));
            Database::disconnect();
            header("Location: index.php");
        }
    } else {
        $pdo = Database::connect();
        $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        $sql = "SELECT * FROM users where id = ?";
        $q = $pdo->prepare($sql);
        $q->execute(array($id));
        $data = $q->fetch(PDO::FETCH_ASSOC);
        $firstName = $data['first_name'];
        $lastName = $data['last_name'];
        $email = $data['email'];
        Database::disconnect();
    }
?>
```
3. Debemos modificar el fichero **index.php** incluyendo el acceso a la página **update.php** pasandole como parámetro el ID del usuario.
```[php]
...
echo '<a class="btn btn-success" href="update.php?id='.$row['id'].'">Update</a>';
...
```
## Delete User - Eliminar usuario
Para eliminar cualquier usuario debemos seguir los siguientes pasos:
1. Creamos el fichero **delete.php** e incluimos el siguiente código HTML.
```[html]
<!DOCTYPE html>
<html lang="en">
<head>
    <title>PHP CRUD - Delete a User</title>
    <meta charset="utf-8">
    <link   href="css/bootstrap.min.css" rel="stylesheet">
    <script src="js/bootstrap.min.js"></script>
</head>
 
<body>
    <div class="container">
     
                <div class="span10 offset1">
                    <div class="row">
                        <h3>Delete a User</h3>
                    </div>
                     
                    <form class="form-horizontal" action="delete.php" method="post">
                      <input type="hidden" name="id" value="<?php echo $id;?>"/>
                      <p class="alert alert-error">Are you sure to delete ?</p>
                      <div class="form-actions">
                          <button type="submit" class="btn btn-danger">Yes</button>
                          <a class="btn" href="index.php">No</a>
                        </div>
                    </form>
                </div>
                 
    </div> <!-- /container -->
  </body>
</html>
```
2. Añadimos al principio del fichero **delete.php** el código php para eliminar el registro de usuario de la tabla **users**.
```[php]
<?php    
    require 'database.php';
    $id = 0;
     
    if ( !empty($_GET['id'])) {
        $id = $_REQUEST['id'];
    }
     
    if ( !empty($_POST)) {
        // keep track post values
        $id = $_POST['id'];
         
        // delete data
        $pdo = Database::connect();
        $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        $sql = "DELETE FROM users  WHERE id = ?";
        $q = $pdo->prepare($sql);
        $q->execute(array($id));
        Database::disconnect();
        header("Location: index.php");
         
    }
?>
```

3. Debemos modificar el fichero **index.php** incluyendo el acceso a la página 
**delete.php** pasandole como parámetro el ID del usuario.
```[php]
...
echo '<a class="btn btn-danger" href="delete.php?id='.$row['id'].'">Delete</a>';
...
```

Después de realizar estos pasos podríamos probar el CRUD de usuarios que hemos creado en PHP7.

