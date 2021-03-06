=begin
def music_shuffle filenames
    # taking one song from the array and then taking another random one and swaps them
    # repeats for every song in the array
len= filenames.length
    p top_song= filenames.pop
    p random_song= filenames.sample
    new_top_song= []
    new_filenames= []
    if top_song == random_song
        random_song= filenames.sample
    else
        
        n= 0
        while n < len
            idx= filenames.index(random_song)
            new_top_song<< filenames.slice!(idx)
           p new_filenames= filenames.insert(idx, top_song)
            top_song= new_top_song
            music_shuffle new_filenames
            p top_song
        p filenames
        n+=1
       end
    end

end

p music_shuffle(['one','two','three','four','five','six','seven','eight','nine','ten','eleven'])
=end

def music_shuffle filenames
  songs_and_paths = filenames.map do |s|
    [s, s.split('/')] # [song, path]
  end

  tree = {:root => []}

  # put each song into the tree
  insert_into_tree = proc do |branch, song, path|
    if path.length == 0 # add to current branch
      branch[:root] << song
    else # delve deeper
      sub_branch = path[0]
      path.shift # like "pop", but pops off the front

      if !branch[sub_branch]
        branch[sub_branch] = {:root => []}
      end

      insert_into_tree[branch[sub_branch], song, path]
    end
  end

  songs_and_paths.each{|sp| insert_into_tree[tree, *sp]}

  # recursively:
  # - shuffle sub-branches (and root)
  # - weight each sub-branch (and root)
  # - merge (shuffle) these groups together
  shuffle_branch = proc do |branch|
    shuffled_subs = []

    branch.each do |key, unshuffled|
      shuffled_subs << if key == :root
      unshuffled # At this level, these are all duplicates.
      else
        shuffle_branch[unshuffled]
      end
    end

    weighted_songs = []

    shuffled_subs.each do |shuffled_songs|
      shuffled_songs.each_with_index do |song, idx|
        num = shuffled_songs.length.to_f
        weight = (idx + rand) / num
        weighted_songs << [song, weight]
      end
    end

    weighted_songs.sort_by{|s,v| v}.map{|s,v| s}
  end
  shuffle_branch[tree]
end

# songs = ['aa/bbb', 'aa/ccc', 'aa/ddd',
#          'AAA/xxxx', 'AAA/yyyy', 'AAA/zzzz', 'foo/bar']
# puts(music_shuffle(songs))

