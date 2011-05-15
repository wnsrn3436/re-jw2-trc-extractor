//파일리스트의 첫 저장

file_delete(global.save+"\"+filename_name(global.load)+"_file_list.trl")
vb_file_list = file_bin_open(global.save+"\"+filename_name(global.load)+"_file_list.trl", 1)

for(i=0; i!=999; i+=1)
{
sk_file_list_1_1_save()

if i=37
{
file_bin_close(vb_file_list)

vb_file_list=file_text_open_append(global.save+"\"+filename_name(global.load)+"_file_list.trl")
file_text_write_string(vb_file_list, filename_name(global.load))
i+=string_length(filename_name(global.load))
file_text_close(vb_file_list)

vb_file_list = file_bin_open(global.save+"\"+filename_name(global.load)+"_file_list.trl", 2)
file_bin_seek(vb_file_list, i)
}

}
file_bin_close(vb_file_list)

// sk_file_list_1_save()
