# Crazy HTML
Crazy html is a language that transpiles to html


## To use
Create a file `.chtml` and run `racket <your-file.chtml>`.

## Example of syntax:
```rkt
#lang reader "reader.rkt"

-- output filename
filename: "page/hello-world.html"

-- file content
tag: html ->
  properties: [{"lang", "en"}]
  childrens:
    tag: head ->
      childrens:
        tag: meta ->
          properties: [{"charset", "UTF-8"}]
        end
        tag: title ->
          childrens: "Hello World"
        end
        tag: link ->
          properties: [{"rel", "stylesheet"}, {"href", "./styles.css"}]
        end
    end
    tag: body ->
      childrens:
        tag: div ->
          childrens:
            tag: h1 ->
               properties: [{"class", "hello-world"}]
               childrens: "Hello World!"
            end
            tag: ul ->
              childrens:
                tag: li ->
                  childrens: "Firt item"
                end
                tag: li ->
                  childrens: "Second item"
                end
            end
        end
    end
end
```
