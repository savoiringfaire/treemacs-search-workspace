;;; treemacs-search-workspace.el --- Search files in Treemacs projects with Helm -*- lexical-binding: t; -*-

;; Version: 1.0.0
;; Author: Marcus Hann <marcus@hhra.uk>
;; URL: https://github.com/savoiringfaire/treemacs-search-workspace
;; Package-Requires: ((emacs "25.1") (helm "3.0") (treemacs "2.0"))

(defun treemacs-search-workspace-all-files ()
  "Return a list of all files in all Treemacs projects."
  (let ((projects (treemacs-workspace->projects (treemacs-current-workspace)))
        (all-files '()))
    (dolist (project projects)
      (let ((path (treemacs-project->path project)))
        (when (file-accessible-directory-p path)
          (setq all-files
                (append all-files
                        (directory-files-recursively path "" t))))))
    (unless all-files
      (user-error "No accessible files found in Treemacs projects"))
    all-files))

(defvar treemacs-search-workspace-helm-source
  '((name . "Treemacs Files")
    (candidates . treemacs-search-workspace-all-files)
    (action . (("Open file" . find-file)
               ("Open file other window" . find-file-other-window)))
    (volatile)))

(defun treemacs-search-workspace ()
  "Search for all files in the current treemacs workspace."
  (interactive)
  (helm :sources 'treemacs-search-workspace-helm-source
        :buffer "*helm treemacs*"))

(provide 'treemacs-search-workspace)
