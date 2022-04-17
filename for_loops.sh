#!/bin/bash

states=('Texas' 'California' 'Colorado' 'Hawaii' 'Alaska')

for state in ${states[@]}
do
    if [ $state == 'Hawaii' ];
    then
      echo "Hawaii is the best!"
    else
      echo "I'm not a fan!"
    fi
  done
