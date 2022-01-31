def define_env(env):
    "Hook function"

    @env.macro
    def test123(page):
        list = []
        while page.next_page:
            list.append(page.next_page)
            page = page.next_page
        return list
    
