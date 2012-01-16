require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase

  # test availability of textilize and CodeRay.highlight
  test "basic textilize should work" do
    @str = textilize('A *simple* paragraph with some _emphasis_ and a "link":http://redcloth.org')
    @res = '<p>A <strong>simple</strong> paragraph with some <em>emphasis</em> and a <a href="http://redcloth.org">link</a></p>'
    assert @str == @res
  end

  test "basic coderay should work" do
    @str = CodeRay.highlight("@product = Product.all", "ruby", :css => :class).strip
    @res = 
'<div class="CodeRay">
  <div class="code"><pre><span class="instance-variable">@product</span> = <span class="constant">Product</span>.all</pre></div>
</div>'    
		puts @str
		puts @res
    assert @str == @res
  end

  # test our own CodeRay helper: coderay_dressed
  
  test "basic code without language in one line" do
    @str = coderay_dressed("@@@ @products = Product.all @@@")   # remove the spaces between the three @ !
    @res = "\n\n<notextile>" + CodeRay.highlight("@products = Product.all", "ruby", :css => :class).strip + "</notextile>\n\n"  # coderay_dressed defaults to ruby
    assert @str == @res
  end

end