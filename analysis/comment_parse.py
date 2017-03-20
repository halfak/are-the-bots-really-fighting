def comment_categorization(row):
    
    reverting_user = str(row['reverting_user_text'])
    
    
    if reverting_user.find("HBC AIV") >= 0:
        return 'AIV helperbot'
    
    try:
        comment = str(row['rev_comment'])
    except Exception as e:
        return 'other'
    
    comment_lower = comment.lower().strip()
    comment_lower = " ".join(comment_lower.split())
 
    if comment == 'nan':
        return "deleted revision"
        
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
    
    
    #   Note: these interwiki links may be a bit broad. They have a country code following
    #   the first [[, but there are many country codes and I need a better way of searching
    #   for that.
    
    elif comment_lower.find("robot: adding [[") >= 0:
        return "interwiki link cleanup -- suspected"
    
    elif comment_lower.find("robot: modifying [[") >= 0:
        return "interwiki link cleanup -- suspected"
    
    elif comment_lower.find("robot: deleting [[") >= 0:
        return "interwiki link cleanup -- suspected"  
    
    elif comment_lower.find("robot: removing [[") >= 0:
        return "interwiki link cleanup -- suspected"      

    elif comment_lower.find("robot adding: [[") >= 0:
        return "interwiki link cleanup -- suspected"
    
    elif comment_lower.find("robot modifying: [[") >= 0:
        return "interwiki link cleanup -- suspected"
    
    elif comment_lower.find("robot deleting: [[") >= 0:
        return "interwiki link cleanup -- suspected"  
    
    elif comment_lower.find("robot removing: [[") >= 0:
        return "interwiki link cleanup -- suspected"      
    
    elif comment_lower.find("robot  adding:[[") >= 0:
        return "interwiki link cleanup -- suspected"
    
    elif comment_lower.find("robot  modifying: [[") >= 0:
        return "interwiki link cleanup -- suspected"
    
    elif comment_lower.find("robot  deleting: [[") >= 0:
        return "interwiki link cleanup -- suspected"  
    
    elif comment_lower.find("robot  removing: [[") >= 0:
        return "interwiki link cleanup -- suspected"    
    
    elif comment_lower.find("link syntax") >= 0:
        return "link syntax fixing"
    
    elif comment_lower.find("links syntax") >= 0:
        return "link syntax fixing" 
    
    elif comment_lower.find(" per") >= 0:
        return "other w/ per justification"  
    
    else:
        return "other"
