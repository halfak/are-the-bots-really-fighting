def interwiki_confirm(str comment):
    """
    Takes a comment string, searches for language codes bordered by 
    two punctuation marks from [](){},: or one punctuation mark and
    one space. Beginning and end of a comment string counts as a
    space, not a punctuation mark.
    """
    import string, re
    
    with open("lang_codes.tsv", "r") as f:
        lang_codes = f.read().split("\n")
        
    lang_codes.pop() # a blank '' is in the list that gets returned
    
    try:
        comment = str(comment)
        comment = comment.lower()
        comment = " " + comment + " "  # pad start and end of string with non-punctuation
        
    except Exception as e:
        return 'other'
    
    for lang_code in lang_codes:
        
        lang_code_pos = comment.find(lang_code)
        lang_code_len = len(lang_code)
        
        char_before = " "
        char_after = " "
        
        if lang_code_pos >= 0:
            char_before = comment[lang_code_pos-1]
        
            #print("Char before: '", char_before, "'", sep='')
             
            char_after = comment[lang_code_pos+lang_code_len]

            #print("Char after: '", char_after, "'", sep='')
            
            if char_before in string.punctuation and char_after in "[]{}(),:":
                #print(lang_code)
                return 'interwiki link cleanup -- suspected'
            
            elif char_before in string.punctuation and char_after == "[]{}(),:":
                #print(lang_code)
                return 'interwiki link cleanup -- suspected'
            
            elif char_before == " " and char_after in "[]{}(),:":
                #print(lang_code)
                return 'interwiki link cleanup -- suspected'


               
    return 'other'
    

def comment_categorization(row):
    """
    Takes a row from a pandas dataframe or dict and returns a string with a
    kind of activity based on metadata. Used with df.apply(). Mostly parses
    comments, but makes some use of usernames too.
    """
    
    reverting_user = str(row['reverting_user_text'])
    
    
    if reverting_user.find("HBC AIV") >= 0:
        return 'AIV helperbot'
    
    try:
        comment = str(row['reverting_comment'])
    except Exception as e:
        return 'other'
    
    comment_lower = comment.lower().strip()
    comment_lower = " ".join(comment_lower.split())
 
    if comment == 'nan':
        return "deleted revision"
    
    elif comment.find("Undoing massive unnecessary addition of infoboxneeded by a (now blocked) bot") >= 0:
        return "botfight: infoboxneeded"
    
    elif comment_lower.find("commonsdelinker") >=0 and reverting_user.find("CommonsDelinker") == -1:
        return "botfight: reverting CommonsDelinker"
        
    elif comment.find("Reverted edits by [[Special:Contributions/ImageRemovalBot") >= 0:
        return "botfight: 718bot vs ImageRemovalBot"
    
    elif comment_lower.find("double redirect") >= 0:
        return "fixing double redirect"
    
    elif comment_lower.find("double-redirect") >= 0:
        return "fixing double redirect"

    elif comment_lower.find("has been moved; it now redirects to") >= 0:
        return "fixing double redirect"
        
    elif comment_lower.find("redirect tagging") >= 0:
        return "redirect tagging/sorting"
    
    elif comment_lower.find("sorting redirect") >= 0:
        return "redirect tagging/sorting"
    
    elif comment_lower.find("change redirected category") >= 0:
        return "category redirect cleanup"
    
    elif comment_lower.find("redirected category") >=0:
        return "category redirect cleanup"
    
    elif comment.find("[[User:Addbot|Bot:]] Adding ") >= 0:
        return "template tagging"
    
    elif comment_lower.find("interwiki") >= 0:
        return "interwiki link cleanup"
    
    elif comment_lower.find("langlinks") >= 0:
        return "interwiki link cleanup"
    
    elif comment_lower.find("iw-link") >= 0:
        return "interwiki link cleanup"
    
    elif comment_lower.find("changing category") >= 0:
        return "moving category"
    
    elif comment_lower.find("recat per") >= 0:
        return "moving category"
    
    elif comment_lower.find("moving category") >= 0:
        return "moving category"
    
    elif comment_lower.find("re-categorisation") >= 0:
        return "moving category"
    
    elif comment_lower.find("removing a protection template") >= 0:
        return "protection template cleanup"
    
    elif comment_lower.find("removing categorization template") >= 0:
        return "template cleanup"    
    
    elif comment_lower.find("rm ibid template per") >= 0:
        return "template cleanup"      
    
    elif comment_lower.find("page is not protected") >= 0:
        return "template cleanup"          
    
    elif comment_lower.find("removing protection template") >= 0:
        return "template cleanup"      
    
    elif comment_lower.find("removing orphan t") >= 0:
        return "orphan template cleanup"
    
    elif comment_lower.find("non-applicable orphan") >= 0:
        return "orphan template cleanup"
    
    elif comment_lower.find("removed orphan t") >= 0:
        return "orphan template cleanup"    
    
    elif comment_lower.find("sandbox") >= 0:
        return "clearing sandbox"
    
    elif comment_lower.find("archiving") >= 0:
        return "archiving"
    
    elif comment_lower.find("duplicate on commons") >= 0:
        return "commons image migration"
    
    elif comment_lower.find("user:mathbot/changes to mathlists") >= 0:
        return "mathbot mathlist updates"
        
    elif comment_lower.find("link syntax") >= 0:
        return "link syntax fixing"
    
    elif comment_lower.find("links syntax") >= 0:
        return "link syntax fixing" 
    
    elif comment_lower.find(" per") >= 0:
        return "other w/ per justification"  
    
    elif comment_lower.find("revert") >= 0:
        return "other w/ revert in comment"  
    
    elif comment_lower.find("rv ") >= 0 or comment_lower.find("rv") == 0:
        return "other w/ revert in comment"  
    
    elif comment_lower.find("wikidata") >= 0:
        return "interwiki link cleanup"
    
    elif comment.find("言語間") >=0:
        return "interwiki link cleanup"
    
    elif comment.find("语言链接") >=0:
        return "interwiki link cleanup"  
    
    elif comment.find("双重重定向") >=0 or comment.find("雙重重定向") >= 0:
        return "fixing double redirect"   

    elif comment.find("二重リダイレクト") >=0:
        return "fixing double redirect"  

    elif comment.lower().find("doble redirección") >=0 or comment.lower().find("redirección doble") >= 0:
        return "fixing double redirect"  

    elif comment.lower().find("duplo redirecionamento") >=0:
        return "fixing double redirect"      
    
    elif comment.lower().find("suppression bandeau") >= 0:
        return "template cleanup"
    
    elif comment.lower().find("archiviert") >= 0:
        return "archiving"
    
    else:
        return interwiki_confirm(comment)
    

# by http://stackoverflow.com/questions/14596884/remove-text-between-and-in-python

def remove_brackets(str test_str):
    """
    Takes a string and returns that string with text in brackets and parentheses removed
    """
    
    test_str = str(test_str)
    ret = ''
    skip1c = 0
    skip2c = 0
    for i in test_str:
        if i == '[':
            skip1c += 1
        elif i == '(':
            skip2c += 1
        elif i == ']' and skip1c > 0:
            skip1c -= 1
        elif i == ')'and skip2c > 0:
            skip2c -= 1
        elif skip1c == 0 and skip2c == 0:
            ret += i
            
    return " ".join(ret.split())
    
    
def namespace_type(item):
    if int(item) == 0:
        return 'article'
    elif int(item) == 14:
        return 'category'
    elif int(item) % 2 == 1:
        return 'other talk'
    else:
        return 'other page'