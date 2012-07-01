(require 'test-simple)
(require 'font-lock)

(load-file "../dbgr/common/buffer/command.el")
(load-file "../dbgr/common/buffer/backtrace.el")
(load-file "../dbgr/common/backtrace-mode.el")
(load-file "../dbgr/debugger/trepan/init.el")
(load-file "./bt-helper.el")

(test-simple-start)

(note "fontify")
(setq temp-cmdbuf (generate-new-buffer "*cmdbuf-test*"))
(setq temp-bt (generate-new-buffer "*bt-test*"))
(with-current-buffer temp-cmdbuf
  (switch-to-buffer temp-cmdbuf)
  (dbgr-cmdbuf-init temp-cmdbuf "trepan" 
		    (gethash "trepan" dbgr-pat-hash))
  
  (switch-to-buffer nil)
  )

(setup-bt 
 "--> #0 METHOD Object#gcd(a, b) in file /test/gcd.rb at line 4
    #1 TOP Object#<top /gcd.rb> in file /test/gcd.rb
	at line 19
"
 temp-bt temp-cmdbuf)

(with-current-buffer temp-bt
  (switch-to-buffer temp-bt)
  (goto-char (point-min))
  (dolist (pair 
	   '(
	     ("#" .     dbgr-backtrace-number )
	     ("METHO" . font-lock-keyword-face )
	     ("Objec" . font-lock-constant-face )
	     ("#"     . font-lock-function-name-face )
	     ("("     . font-lock-variable-name-face )
	     ("/test" . dbgr-file-name)
	     ("line " . dbgr-line-number)
	     ("#"     . dbgr-backtrace-number)
	     ("Objec" . font-lock-constant-face )
	     ("<top"  . font-lock-variable-name-face)
	     ("/test" . dbgr-file-name)
	     ("line " . dbgr-line-number)
	     ))
    (search-forward (car pair))
    (assert-equal (cdr pair)
		  (get-text-property (point) 'face))
    )
  (switch-to-buffer nil)
  )

(end-tests)
