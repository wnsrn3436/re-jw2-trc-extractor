//파일을 만듭니다

dll39_buffer_clear(0)

sk_file_list_2_save()

open_file = dll39_file_open(global.load, 0)
dll39_file_set_pos(open_file, global.front_head+global.front_head2)
dll39_file_read(open_file, global.file_length[progress], 0)
dll39_file_close(open_file)

save_file = dll39_file_open(global.save+"\"+file_folder2+"\"+global.file_name[progress], 1)
dll39_file_write(save_file, 0)
dll39_file_close(save_file)

// sk_save()
