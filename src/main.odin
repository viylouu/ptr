package main

import "core:fmt"
import "core:os"
import "core:strings"

main :: proc() {
    args := os.args[1:]
    
    assert(len(args) == 2)
    assert(args[0] == "run")

    f, err := os.open(args[1])
    assert(err == os.ERROR_NONE)
    defer os.close(f)

    fis: []os.File_Info
    defer os.file_info_slice_delete(fis)

    fis, err = os.read_dir(f, -1)
    assert(err == os.ERROR_NONE)

    for fi in fis {
        assert(!fi.is_dir)

        data, ok := os.read_entire_file(fi.fullpath)
        defer delete(data)
        assert(ok)

        file := string(data)

        is_comment := false
        curln := strings.builder_make_len(len(file))

        i := 0
        for i < len(file) {
            if file[i] == '/' do if file[i+1] == '/' do for file[i] != '\n' do i += 1
            if i < len(file) {
                strings.write_rune(&curln, rune(file[i]))
                if file[i] == '\n' {
                    cur := strings.clone(strings.to_string(curln))
                    wa: bool
                    cur, wa = strings.remove_all(cur, "\t")
                    cur, wa = strings.remove_all(cur, "  ")
                    if cur != "\n" do fmt.print(cur)
                    strings.builder_reset(&curln)
                    delete(cur)
                }
            }

            i += 1
        }
    }
}
