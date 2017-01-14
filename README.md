# unique_links.sh bash script

## Usage

```sh
unique_links.sh -add destination-directory source-file-or-directory ...
unique_links.sh -del destination-directory source-file-or-directory ...
```

## -add

"unique_links.sh -add" creates symbolic links to the specifiled files except for entirely duplicate files.

For example, following command creates symbolic links under 'output' directory to plain files under ~/Backups/\*/Pictures. Created symbolic links are named from the hash code of file contents. If there are entirely duplicate files under ~/Backups/\*/Pictures, the corresponding symbolic link is created only once.

```sh
% mkdir output
% unique_links.sh -add output ~/Backups/*/Pictures
```

```sh
% ls output
0ba1e28b.JPG
0bcc62b5.plist
0bd05cfd.JPG
0c1d20ed.JPG
0c2505ad.JPG
0c751be8.JPG
0d1762ef.db
0e195fdd.JPG
0f4a0a37.JPG
0f7297ce.JPG
0f932695.DS_Store
0f9798c1.JPG
```


## -del

"unique_links.sh -del" deletes symbolic links which has created by "unique_links.sh -add". If a symbolic link corresponds to a file which has duplicate content of one of the specifiled files, it is deleted.

For example, after above example, following command deletes symbolic links under 'output' directory which are included in ~/Pictures.

```sh
% unique_links.sh -del output ~/Pictures
```
