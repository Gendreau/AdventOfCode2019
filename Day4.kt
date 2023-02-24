fun main() {
    val lower_bound = 246540
    val upper_bound = 787419
    val isPartOne = false
    var possible_passwords = 0
    
    for (i in lower_bound..upper_bound) {
        var str = i.toString()
        if (!ascending(str) or !hasDouble(str)) {continue}
        if (!isPartOne and !hasTriple(str)) {continue}
        possible_passwords++
    }
    print(possible_passwords)
}

fun ascending(str: String): Boolean {
    for (c in 1..str.length-1) {
        if (str.get(c) < str.get(c-1)) {return false}
    }
    return true
}

fun hasDouble(str: String): Boolean {
    val doubles = arrayOf<String>("00","11","22","33","44","55","66","77","88","99")
    for (dd in doubles) {
        if (str.contains(dd)) {return true}
    }
    return false
}

fun hasTriple(str: String): Boolean {
    val triples = arrayOf<String>("000","111","222","333","444","555","666","777","888","999")
    for (tt in triples) {
        if (str.contains(tt.substring(1)) and !str.contains(tt)) {return true}
    }
    return false
}