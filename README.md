# dotfiles
Personal dofiles


cloning files

`git clone --bare https://github.com/Danny-Dasilva/.dotfiles.git` (or your fork)

`echo 'alias dotfiles="/usr/bin/git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME"' >> $HOME/.dotfiles`

`source ~/.dotfiles `

`dotfiles checkout`


How to commit 

`dotfiles add $your_file `

`dotfiles commit -m "My message"`


`dotfiles push origin master`


in case of no origin error

`dotfiles remote add origin https://github.com/Danny-Dasilva/.dotfiles.git`


How to update from repo
`dotfiles pull`
