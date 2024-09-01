# Install Hydro (https://github.com/jorgebucaran/hydro)
echo "Installing Hydro..."
fish -c "fisher install jorgebucaran/hydro"

# Ensure it's up to date
fish -c "fisher update"

# Configure Hydro
echo "Configuring Hydro..."

# Colors
# (To see the list of all named colors, run `set_color --print-colors`)
fish -c "set --universal hydro_color_pwd brblue"
fish -c "set --universal hydro_color_git brgreen"
fish -c "set --universal hydro_color_error red"
fish -c "set --universal hydro_color_prompt normal"
fish -c "set --universal hydro_color_duration yellow"

# Ensure that the working directory is not truncated
fish -c "set --universal fish_prompt_pwd_dir_length 99"

# Enable background git fetches
fish -c "set --universal hydro_fetch true"

# Install sponge (https://github.com/meaningful-ooo/sponge)
fish -c "fisher install meaningful-ooo/sponge"

# Install autopair (https://github.com/jorgebucaran/autopair.fish)
fish -c "fisher install jorgebucaran/autopair.fish"
