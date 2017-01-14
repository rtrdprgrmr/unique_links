# unique_links.sh bash script

## Usage

```sh
unique_links.sh -add destination-directory source-file-or-directory ...
unique_links.sh -del destination-directory source-file-or-directory ...
```

## -add

"unique_links.sh -add" creates symbolic links to the specifiled files except for entirely duplicate files.

For example, following command creates symbolic links under 'output' directory to plain files under ~/Backups/*/Pictures. Created symbolic links are named from the hash code of file contents. If there are entirely duplicate files under ~/Backups/*/Pictures, the corresponding symbolic link is created only once.

```sh
% mkdir output
% unique_links.sh -add output ~/Backups/*/Pictures
```

```sh
% ls output
0ba1e28be7d68b19ed883e678392e6cb.JPG
0bcc62b54d605baf0beeb606aee96e25.plist
0bd05cfda4e1f39bf5f08b69eb66d9f9.JPG
0c1d20edaf11631f57d5afc5d61438d9.JPG
0c2505ad783bf25d6a4c39017328fd6c.JPG
0c751be8bfc7fc8b447f167e53218c56.JPG
0d1762ef6b552b0fa7109210ce41787b.db
0e195fddfbd378eb14e39d1ccb734c9b.JPG
0f4a0a37c6c5fbca6fdf392e8a9e87db.JPG
0f7297ce17c9fe0eeafbce2231ea56e5.JPG
0f932695524fb03a9260e9a5cee6a8c9.DS_Store
0f9798c1189a68831fed96693c3a66d2.JPG
```


## -del

"unique_links.sh -del" deletes symbolic links which has created by "unique_links.sh -add". If a symbolic link corresponds to a file which has duplicate content of one of the specifiled files, it is deleted.

For example, after above example, following command deletes symbolic links under 'output' directory which are included in ~/Pictures.

```sh
% unique_links.sh -del output ~/Pictures
```
