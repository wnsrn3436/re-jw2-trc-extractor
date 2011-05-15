//파일리스트의 파일이름 저장

vb_file_list = file_bin_open(global.save+"\"+filename_name(global.load)+"_file_list.trl", 2)
file_bin_seek(vb_file_list, file_bin_size(vb_file_list))
sk_fl12s('0D'); file_bin_seek(vb_file_list, file_bin_size(vb_file_list))
sk_fl12s('0A'); file_bin_seek(vb_file_list, file_bin_size(vb_file_list))
sk_fl12s('09')
file_bin_close(vb_file_list)

vb_file_list=file_text_open_append(global.save+"\"+filename_name(global.load)+"_file_list.trl")
file_text_write_string(vb_file_list, file_folder2+"\"+global.file_name[progress])
file_text_close(vb_file_list)

// sk_file_list_2_save()
