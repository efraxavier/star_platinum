module Helper
    def take_pic(file_name, result)
        file_path = "report/screenshots/test_#{result}"
            pic = "#{file_path}/#{file_name}.png"
            page.save_screenshot(pic)
            embed(pic, 'image/png', 'Click here')
    end
end