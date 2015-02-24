# Examples and exercises from programming from the ground up
### Link 
Book is found [here](http://programminggroundup.blogspot.com/)

### Why?
It is interesting. Why not learn what makes my computer tick?

### Notes
1. I found it difficult to start learning about assembly (and I'm still very much in the learning process). Hopefully this will help some people get started.
2. I had difficulty assembling and linking these programs at first. I am using linux amd64 and they work just fine. I forgot the period in the following and it caused problems:
```
.section .data
.section .text
```
Make sure you don't forget the periods. You will get a corrupted header size in the executable, and it won't work.

* To assemble: 
```
as --32 <filename> -o <outputname>
```
* To link:
```
ld -m elf_i386 <filename> -o <outputname>
```
