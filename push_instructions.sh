# Once you've created the repository on GitHub, run these commands:

# Option 1 - Use HTTPS:
git remote add origin https://github.com/YOUR_USERNAME/config-backup.git
git branch -m main
git add .
git commit -m "Initial commit: Add helix and waybar configs"
git push -u origin main

# Option 2 - Use SSH (if you have SSH keys set up):
git remote add origin git@github.com:YOUR_USERNAME/config-backup.git
git branch -m main
git add .
git commit -m "Initial commit: Add helix and waybar configs"
git push -u origin main

# After pushing to GitHub, you can restore configs on a new system with:
git clone https://github.com/YOUR_USERNAME/config-backup.git
cd config-backup
cp -r helix/* ~/.config/helix/
cp -r waybar/* ~/.config/waybar/
