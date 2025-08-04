package main

import "core:fmt"
import "core:os"
import "core:strings"

libs: map[string]string

main :: proc() {
    libs["stdarr"] = #load("../lib/stdarr.ptr")
    libs["stdif"] = #load("../lib/stdif.ptr")
    libs["stdio"] = #load("../lib/stdio.ptr")
    libs["stdloop"] = #load("../lib/stdloop.ptr")
    libs["stdmem"] = #load("../lib/stdmem.ptr")

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
        includes: map[string]bool

        i := 0
        for i < len(file) {
            if file[i] == '/' do if file[i+1] == '/' do for file[i] != '\n' do i += 1
            strings.write_rune(&curln, rune(file[i]))
            if file[i] == '\n' {
                cur := strings.clone(strings.to_string(curln))

                if strings.has_prefix(cur, "lib ") {
                    cur = strings.trim_prefix(cur, "lib ")
                    cur = strings.trim_suffix(cur, "\n")
                    if includes[cur] do break
                    includes[cur] = true
                    cur = libs[cur]
                }
                
                fmt.print(cur)
                strings.builder_reset(&curln)
            }

            i += 1
        }
    }
}

// todo: make the for loop thing in here and recursive instead
//load :: proc(data: string, )
