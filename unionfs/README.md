This is a basic example of union-fuse file system usage. It's can be
compiled only with zrt extensions enabled, see
toolchain/build_zrt_fs_extensions.sh.  This example do mount of
read-only tar archive into /mnt/tar folder and then by using unionfs
we do mount of RO folder /mnt/tar and RW folder /tmp into /tar folder
with RW access. From now contents of tar archive available in /tar
folder and can be modified. All modifications transparently will be
saved into /tmp folder by unionfs. All data in /tmp will be freed at
exit.