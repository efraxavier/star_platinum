module Helper
    def take_pic(file_name, result)
        file_path = "media/screenshots/test_#{result}"
            pic = "#{file_path}/#{file_name}.png"
            page.save_screenshot(pic)
            attach(pic, 'image/png')
    end
end