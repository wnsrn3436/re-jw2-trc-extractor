# TRC archive format

Analysis of the archive format (TRC) in which Jurassic Primitive War 2 bundles its game data. The file starts with a file table of 32 byte entries, followed by each file's data. The details below were confirmed against The Ranker's `jw2_01.trc` (14 files, all uncompressed).

## Header entry

The first entry is a header rather than a file.

```
54 52 43 1A   "TRC" + 0x1A
0E 00 00 00   file count
0E 00 00 00   file count (the same value again)
E0 01 00 00   total table length (header entry included, 32 × entry count)
00 × 16       0
```

Dividing the table length at `0x0C` by 32 gives the entry count, and minus the header entry that is the file count. File data starts where the table ends, which is this value.

## File entry

Each entry points at one file. All values are little endian.

Example (`fe1215rd.fn`):

```
66 65 31 32 31 35 72 64 2E 66 6E 00  filename "fe1215rd.fn" (null terminated)
00 B8 00 00                          data start position (relative to the end of the table)
00 B5 00 00                          original size
00 B5 00 00                          compressed size
21 4D                                checksum
00 00                                compression method
00 00 00 00                          0
```

| Offset | Size | Meaning |
|---|---|---|
| `+0x00` | 12 | Filename, null terminated |
| `+0x0C` | 4 | Data start position. Relative to the end of the table, so the first file is 0 |
| `+0x10` | 4 | Original size |
| `+0x14` | 4 | Compressed size |
| `+0x18` | 2 | Checksum. The low 16 bits of the sum of every byte in the file data. Editing the data after packing leaves this value as it was |
| `+0x1A` | 2 | Compression method. 00 uncompressed / 01 dictionary based / 02 ZIP |
| `+0x1C` | 4 | 0 |

## Compression

The compression method field is per file, so within a single TRC the files can mix uncompressed, dictionary based, and ZIP storage.

## What this extractor reads

This tool targets an uncompressed archive. It reads the table length from the header to get the entry count, then reads each entry's filename (`+0x00`) and size (`+0x14`). File data follows the table in table order, so it cuts each file out by its size in sequence.

## Repack listing (.trl)

Extraction also produces `<original name>_file_list.trl`. It records, as instructions, the order in which the files should be bundled back together, so the archive can be repacked later.
