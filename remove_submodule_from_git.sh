#!/bin/bash
# remove_submodule_from_git.sh : remove --chached from all the submodule using for loop
#
for d in AWS-TERRAFORM/terraform-aws-*; do
  git rm --cached "$d"
done