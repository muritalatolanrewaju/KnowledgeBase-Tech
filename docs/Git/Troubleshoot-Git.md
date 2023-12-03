# Troubleshoot Git

## Change Last Commit

```bash
git commit --amend
```

## Push Amended Commit to Remote

```bash
git push --force-with-lease origin EXAMPLE-BRANCH
```

## Reset last commit

```bash
git reset --soft HEAD~1
```

## Unstage files

```bash
git reset HEAD <file>
```

## Stash local changes

Stash Your Changes: This will temporarily save your local changes and revert your working directory to the state of the last commit.

```bash
git stash
```

Pull the Latest Changes: This will fetch the latest changes from the remote repository and merge them into your current branch.

```bash
git pull
```

Apply Your Stashed Changes: This will reapply your local changes on top of the latest changes from the remote repository.

```bash
git stash pop
```

After these steps, you'll have the latest changes from the remote repository merged into your branch, and your local changes will still be present and unstaged.

> Note: If there are conflicts between your local changes and the changes from the remote repository, you'll need to resolve them manually after running git stash pop.
