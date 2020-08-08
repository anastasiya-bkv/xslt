<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template match="/">
		<HTML>
			<HEAD>
				<xsl:call-template name="styles" />
			</HEAD>
			<BODY>
				<div class="table__row">
					<div class="table__item">№</div>
					<div class="table__item">Название</div>
					<div class="table__item">Автор</div>
					<div class="table__item">Цена</div>
					<div class="table__item"></div>
				</div>
				<xsl:for-each select="books/book">
					<div class="table__row">
						<div class="table__item">
							<xsl:value-of select="position()"/>
						</div>
						<div class="table__item">
							<xsl:value-of select="name" />
						</div>
						<div class="table__item">
							<xsl:value-of select="author" />
						</div>
						<div class="table__item">
							<xsl:variable name="price">
								<xsl:value-of select="format-number(price, '#.00', 'df')"/>
							</xsl:variable>

							<xsl:call-template name="declension">
								<xsl:with-param name="number" select="substring-before($price, '.')" />
								<xsl:with-param name="nominative">
									<xsl:text> рубль </xsl:text>
								</xsl:with-param>
								<xsl:with-param name="genitive_singular">
									<xsl:text> рубля </xsl:text>
								</xsl:with-param>
								<xsl:with-param name="genitive_plural">
									<xsl:text> рублей </xsl:text>
								</xsl:with-param>
							</xsl:call-template>

							<xsl:call-template name="declension">
								<xsl:with-param name="number" select="substring-after($price, '.')" />
								<xsl:with-param name="nominative">
									<xsl:text> копейка </xsl:text>
								</xsl:with-param>
								<xsl:with-param name="genitive_singular">
									<xsl:text> копейки </xsl:text>
								</xsl:with-param>
								<xsl:with-param name="genitive_plural">
									<xsl:text> копеек </xsl:text>
								</xsl:with-param>
							</xsl:call-template>
						</div>
						<div class="table__item">
							<button class="table__btn-pay btn-pay">Оплатить</button>
						</div>
					</div>
				</xsl:for-each>

				<div class="modal " tabindex="-1" role="dialog" id="modalBlock">
					<div class="modal-dialog modal-dialog-centered" role="document">
						<div class="modal-content">
							<form action="#" id="card" class="form">
								<div class="form__row">
									<div class="form__label">Номер карты</div>
									<div class="form__input">
										<input type="text" name="card" placeholder="999 9999 9999 9999" required="true"/>
									</div>
								</div>
								<div class="form__row">
									<div class="form__label">Держатель</div>
									<div class="form__input">
										<input type="text" name="owner" placeholder="Иванов Иван Иванович" required="true"/>
									</div>
								</div>
								<div class="form__row">
									<div class="form__label">Срок/CVV</div>
									<div class="form__input">
										<input type="text" name="term" placeholder="99 / 99" required="true"/>
										<span class="split"> / </span>
										<input type="text" name="cvv" placeholder="999" required="true"/>
									</div>
								</div>
								<button type="submit" class="form__btn-pay btn-pay">Оплата</button>
							</form>
						</div>
					</div>
				</div>
				<xsl:call-template name="scripts" />
			</BODY>
		</HTML>
	</xsl:template>

	<xsl:decimal-format name = "df" grouping-separator = " "/>

	<xsl:template name="declension">
		<xsl:param name="number" select="number"/>
		<xsl:param name="nominative" select="nominative"/>
		<xsl:param name="genitive_singular" select="genitive_singular"/>
		<xsl:param name="genitive_plural" select="genitive_plural"/>

		<xsl:variable name="last_digit">
			<xsl:value-of select="$number mod 10"/>
		</xsl:variable>
		<xsl:variable name="last_two_digits">
			<xsl:value-of select="$number mod 100"/>
		</xsl:variable>

		<xsl:choose>
			<xsl:when test="$number > 0">
				<xsl:value-of select="format-number($number, '### ###', 'df')"/>
				<xsl:choose>
					<xsl:when test="$last_digit = 1 and $last_two_digits != 11">
						<xsl:value-of select="$nominative"/>
					</xsl:when>
					<xsl:when test="
                $last_digit = 2 and $last_two_digits != 12
                or
                $last_digit = 3 and $last_two_digits != 13
                or
                $last_digit = 4 and $last_two_digits != 14
                ">
						<xsl:value-of select="$genitive_singular"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$genitive_plural"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="styles">
		<style type="text/css">
	.table__row{
	display: flex;
	justify-content: space-around;
	align-items: center;
	margin-bottom: 1rem;
	}
	.table__item{
	flex: 1 0 20%
	}
	.btn-pay{
		padding: 8px 20px;
		background-color: #3c9092;
		color: #fff;
		border: none;
		outline: none;
		border-radius: 5px;
		box-shadow: 1px 1px 3px #7d7d7d;
	}
	.modal-content{
		align-items: center;
		padding-top: 20px;
		padding-bottom: 20px;
	}
	.modal {
		position: fixed;
		top: 0;
		left: 0;
		z-index: 1050;
		display: none;
		width: 100%;
		height: 100%;
		overflow: hidden;
		outline: 0;
		background: rgba(0, 0, 0, 0.5);
	}
	.modal-dialog{
		min-width: 650px;
	}
	.show {
		display: block;
	}
	.form {
		padding: 1rem;
	}
	.form__row{
		display: flex;
		margin-bottom: 1rem;
	}
	.form__label{
		flex: 1 0 25%
	}
	.form__input{
		display: flex;
		flex: 1 0 75%
	}
	.form__input:invalid{
		border-color: red;
	}
	.form__btn-pay{
		display: flex;
		margin: auto;
	}
	.split{
		margin: 0 5px;
	}
		</style>
	</xsl:template>

	<xsl:template name="scripts">
		<script type="text/javascript">
		</script>
	</xsl:template>
</xsl:stylesheet>
