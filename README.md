# Jurassic Primitive War 2 TRC Extractor

An extractor that pulls the individual files out of TRC, the archive format Jurassic Primitive War 2 uses to bundle its game data. It reads the file table at the start of the archive to cut each file out, and while extracting it also writes a listing (.trl) that can be used to pack them again.

The analysis is written up in [docs/trc-format.md](docs/trc-format.md).

<p>
  <img src="docs/screenshots/screenshot-1.png" width="306" alt="Extraction screen">
</p>


## How to use

Download from Releases, extract and run it, and a file dialog opens first. Pick the `.trc` to extract, then choose where to save in the folder dialog that follows, and it takes it from there.

A numbered subfolder is created inside the output folder and the extracted files go there. If a file of the same name already exists, the next number is used for a new folder. `<original name>_file_list.trl` lands directly in the output folder.


## How it works

**The file table gives the count and the lengths.** A TRC starts with a table of 32 byte entries. The total table length at `0x0C` in the header gives the number of entries, and each entry holds the file name (`+0x00`, 12 bytes) and the length (`+0x14`, 4 bytes).

```gml
// table length from the header -> entry count
for(j=0; j!=4; j+=1){ file_bin_seek(open_file, 12+j); file_s[j]=sk_hex_conversion(file_bin_read_byte(open_file)) }
global.front_head = real(sk_dec_conversion(file_s[3]+file_s[2]+file_s[1]+file_s[0]))

// length per entry (+0x14)
for(j=0; j!=4; j+=1){ file_bin_seek(open_file, i*32+20+j); file_s[j]=sk_hex_conversion(file_bin_read_byte(open_file)) }
global.file_length[i] = real(sk_dec_conversion(file_s[3]+file_s[2]+file_s[1]+file_s[0]))
```

**The actual byte I/O is handed to 39DLL.** The data region follows the table in order. When a file's turn comes, `dll39_file_set_pos` seeks to its start, reads its length into a buffer, and writes that straight out. The external DLL was used for faster file handling than the built in GML functions.

```gml
open_file = dll39_file_open(global.load, 0)
dll39_file_set_pos(open_file, global.front_head+global.front_head2)
dll39_file_read(open_file, global.file_length[progress], 0)
dll39_file_close(open_file)
save_file = dll39_file_open(global.save+"\"+file_folder2+"\"+global.file_name[progress], 1)
dll39_file_write(save_file, 0)
```

**A repack listing is built during extraction.** Every time a file is pulled out, its entry is appended to the `.trl` as a repack instruction.


## Files

| Path | Contents |
|---|---|
| `source/jw2-trc-extractor.gmk` | Original project file |
| `source/split/` | Text tree produced by GmkSplitter |
| `source/39DLL EXT.gex` | The 39DLL extension the build needs |
| `docs/trc-format.md` | TRC format analysis |
| `docs/screenshots/` | Screenshots |
| Releases | Executable and usage notes |

Opening the source in GameMaker needs the 39DLL extension installed. `source/39DLL EXT.gex` is that extension.


## Credits

39DLL is a widely used file and networking DLL for GameMaker, made by 39ster. The Korean text scripts under `source/split/Scripts/한글드로우/` were written by 김게맛 (sodium031) of the GameMaker community.


## License

zlib. See [LICENSE](LICENSE). Bundled libraries made by other people keep their own licenses.
