# wordpress-fix-permissions.sh

This script is designed to set the correct permissions for files and directories in a WordPress installation. It ensures that the permissions are applied recursively, providing a secure and functional environment for your WordPress site.

## Features

- Recursively sets permissions for WordPress files and directories
- Ensures secure and functional permissions
- Easy to use and customize

## Usage

1. **Place the script in your WordPress directory**:

   mv wordpress-fix-permissions.sh /path/to/your/wordpress/installation
   

2. **Make the script executable**:
   
   chmod +x /path/to/your/wordpress/installation/wordpress-fix-permissions.sh
   

3. **Run the script**:
   
   cd /path/to/your/wordpress/installation
   ./wordpress-fix-permissions.sh

## Permissions Set by the Script

- **Directories**: `755`
- **Files**: `644`
- **wp-config.php**: `600`

## Example

cd /var/www/wordpress
./wordpress-fix-permissions.sh

## Notes

- Ensure you have the necessary permissions to change file and directory permissions.
- It's recommended to run this script as the user who owns the WordPress files.

## Contributing

Feel free to submit issues or pull requests if you have suggestions for improvements or find any bugs.

## Acknowledgments

- Inspired by various WordPress security guides and best practices.
